#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

class Foil
  def initialize
    @page = 0
    @indent = 0
    @file = nil
    @title = ''
    @titles = []
    @printer_mode = false
  end

  def gyazzname(name)
    @gyazzname = name
  end

  def printer_mode
    @printer_mode = true
  end

  def beginpage
    if @printer_mode then
      if @page == 0 then
        @file = File.open("slide.html","w")
        @page = 1
        @file.print pagehead
      end
      @file.print slidehead
    else
      @page += 1
      @file = File.open("page#{@page}.html","w")
      @titles << @title
      @file.print pagehead
      @file.print slidehead
    end
  end

  def endpage(force=false)
    if @file then
      if @oldindent > 0 then
        @oldindent.times {
          @file.puts "</ul>"
        }
      end
      if !@printer_mode || force then
        @file.print pagebottom
        @file.close
      end
    end
  end

  def prevpage
    @page == 1 ? 1 : @page-1
  end

  def nextpage
    @page+1
  end

  def close
    @oldindent = @indent
    endpage(true)
  end

  def process_tag(line)
    line.gsub!(/''/,"&#148;")
    line.gsub!(/\`\`/,"&#147;")
    images = []

    head = ''
    tail = ''
    while line =~ /^([^\]]*)\[\[\[([^\[]*\.(png|jpg|gif)[^\[]*)\]\]\](.*)$/i do
      images << $2
      head = $1
      tail = $4
      line = head + tail
      # puts "line = '#{line}'"
    end
    if images.length > 0 then
      s = ''
      images.each { |image|
        # puts "image = #{image}"
        image =~ /^(\S+)(\s+(.*))?$/
        url = $1
        desc = $3
        # puts "url=#{url}, desc=#{desc}"
        descs = desc.to_s.split(/\s+/)
        if descs[0] =~ /\.(png|jpg|gif)$/i then
          s += "<a href='#{url}'><img src='#{descs[0]}' border=none #{descs.shift; descs.join(' ')}></a>"
        elsif url =~ /\.(png|jpg|gif)$/i then
          s += "<img src='#{url}' #{desc}>"
        else
          # puts "aaaaaaa"
        end
      }
      line = head + "<center>#{s}</center>" + tail
      # puts "line = <#{line}>"
    end
    line.gsub!(/\[\[\[([^\[]*)\]\]\]/){
      s = $1
      "<strong>#{s}</strong>"
    }

#    line.gsub!(/\[\[\[([^\[]*)\]\]\]/){
#      s = $1
#      s =~ /^(\S+)(\s+(.*))?$/
#      url = $1
#      desc = $3
#      descs = desc.to_s.split(/\s+/)
#      if descs[0] =~ /\.(png|jpg|gif)$/i then
#        "<center><a href='#{url}'><img src='#{descs[0]}' border=none #{descs.shift; descs.join(' ')}></a></center>"
#      elsif url =~ /\.(png|jpg|gif)$/i then
#        "<center><img src='#{url}' #{desc}></center>"
#      else
#        "<strong>#{s}</strong>"
#      end
#    }
    line.gsub!(/\[\[([^\[]*)\]\]/){
      $1 =~ /^(\S+)(\s+(.*))?$/
      url = $1
      desc = $3
      descs = desc.to_s.split(/\s+/)
      if descs[0] =~ /\.(png|jpg|gif)$/i then
        "<center><a href='#{url}'><img src='#{descs[0]}' border=none #{descs.shift; descs.join(' ')}></a></center>"
      elsif url =~ /\.(png|jpg|gif)$/i then
        "<center><img src='#{url}' #{desc}></center>"
      else
        if url =~ /^http/ || url =~ /html$/ then
          if desc.nil? then
            "<a href='#{url}'>#{url}</a>"
          else
            "<a href='#{url}'>#{desc}</a>"
          end
        else
          "<a href='http://Gyazz.com/#{@gyazzname}/#{url}'>#{url}</a>"
        end

#        if desc.nil? then
#          if url =~ /^http/ || @gyazzname.nil? then
#            "<a href='#{url}'>#{url}</a>"
#          else
#            "<a href='http://Gyazz.com/#{@gyazzname}/#{url}'>#{url}</a>"
#          end
#        else
#          "<a href='#{url}'>#{desc}</a>"
#        end
      end
    }
    line
  end
    
  def process(line)
# STDERR.puts line
    return if line =~ /^\s*$/     # 空行除去
    return if line =~ /^\s*[#%]/  # コメント除去
    if line =~ /^\s+</ then
      @file.puts line
      return
    end
    origline = line.dup
    line = process_tag(line)
    line =~ /^(\s*)(\S[^\{]*)(\{(.*)\}\s*)?$/
    @oldindent = @indent
    @indent = $1.length
    @line = $2
    @eline = $4
    if @indent == 0 then
      @title = @line
      @htmlheader = (origline =~ /^</)
      @title_extra = ''
      @title_extra = "<div class='english'><b>#{@eline}</b></div>" if @eline
      endpage
      beginpage
    else
      if @indent == @oldindent then
        @file.puts "<li> " unless @line =~ /img src/
        @file.puts "#{@line}"
        @file.puts "</li><span class='english'>#{@eline}</span>" if @eline
      else
        if @indent > @oldindent then
          (@indent-@oldindent).times {
            @file.puts "<ul>"
          }
        else
          (@oldindent-@indent).times {
            @file.puts "</ul>"
          }
        end
        @file.puts "<li> " unless @line =~ /img src/
        @file.puts "#{@line}"
        @file.puts "</li><span class='english'>#{@eline}</span>" if @eline
      end
    end
  end

  def toc
    File.open("TOC.html","w"){ |f|
      f.print <<EOF
<html>
<head>
<title> 目次 </title>
<meta http-equiv="Content-Type" Content="text/html; charset=utf-8">
</head>
<body bgcolor=#0000ff vlink=#ffffff alink=#ffffff link=#ffffff>
<center>
<font size=5 color=white><b> 目次 </b></font>
</center>
<hr size=4 noshade>
<font size=3 color=white>
<ol>
EOF
      (0...@titles.length).each { |i|
        f.puts "<li> <a href=\"page#{i+1}.html\">#{@titles[i]}</a>"
      }
      f.print <<EOF
</ol>
</body>
</html>
EOF
    }
  end

  def browser_css
    <<EOF
strong {
  color:yellow;
}
.title {
  font-size:40pt;
  color:white;
}
.li {
	font-size:40pt;
        color:white;
}
.ul {
	font-size:40pt;
        color:white;
}
.pagestart {
  page-break-before: always;
}
.pageheader {
  font-size:40pt;
  font-style:normal;
  font-family:arial black;
}
.pagebody {
  font-size:35pt;
  color:white;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
}
.english {
  font-size:20pt;
  color:white;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
}
th {
  font-size:24pt;
  color:white;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
  background-color:#8888c8;
}
td {
  font-size:24pt;
  color:white;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
}
EOF
  end

  def printer_css
    <<EOF
.title {
  font-size:40pt;
}
.pagestart {
  page-break-before: always;
}
.pageheader {
  color: black;
  font-size:35pt;
  font-style:normal;
  font-family:arial;
  font-weight:bold;
}
.pagebody {
  font-size:26pt;
  color:black;
  font-style:normal;
  font-family:arial;
  /* font-weight:bold; */
}
.urllist {
  font-size:14pt;
  color:black;
  font-style:normal;
  font-family:helvetica;
}
a:link {
  color:black;
  text-decoration: none;
}
a:visited {
  color:black;
  text-decoration: none;
}
.english {
  font-size:20pt;
  color:black;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
}
th {
  font-size:24pt;
  color:black;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
  background-color:#8888c8;
}
td {
  font-size:24pt;
  color:black;
  font-style:normal;
  font-family:arial black;
  font-weight:bold;
}
strong {
  color: orange;
}
EOF
  end

  def pagehead
    css = (@printer_mode ? printer_css : browser_css)
    only_browser = (@printer_mode ? '//' : '')
    <<EOF
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>#{@title}</title>
<style type="text/css">
<!--
#{css}
-->
</style>
</head>
<body vlink=white link=white text=white>
<script language="JavaScript">
<!--
function RandomBlue()
{
  var colorstr = "";
  for(var i=0;i<4;i++){
    colorstr += Math.floor(Math.random() * 10).toString(16);
  }
  for(var i=0;i<2;i++){
    colorstr += Math.floor(6 + Math.random() * 9).toString(16);
  }
  return colorstr;
}
document.onkeypress = keypress;
function keypress(event)
{
  var i = keycode(event);
  if(i == 0x75 || i == 0x74 || i == 0x55 || i == 0x54){
    window.location.href="TOC.html";
  }
  if(i == 0x20){
    window.location.href="page#{nextpage}.html";
  }
  if(i == 0x08 || i == 0x7f || i == 0x62){
    window.location.href="page#{prevpage}.html";
  }
}
function keycode(event)
{
  if(navigator.appName.indexOf("Microsoft") != -1)
    return window.event.keyCode;
  //if(navigator.appName.indexOf("Netscape") != -1)
  else
    return event.which;
}
#{only_browser} document.body.style.backgroundColor = '#' + RandomBlue();
//-->
</script>
EOF
  end

  def slidehead
    titleheader = <<EOF
<table width=100%><tr valigh=top align=center><td align=center>
<div class="pageheader"><b>#{@title}</b></div>
#{@title_extra}
</td></tr></table>
</div>
<hr size=4>
EOF
    if @htmlheader then
      titleheader = @title
    end
    <<EOF
<div class="pagestart">
#{titleheader}
<div class="pagebody">
EOF
  end

  def pagebottom
    <<EOF
</div>
</body>
</html>
EOF
  end
end
