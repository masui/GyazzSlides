# GyazzSlide

Gyazzデータからスライドを作るシステム

- gyazz2html
- gyazz2md

## gyazz2md

- Gyazz上のスライドデータをMarkdownに変換します
- glide.so で利用できます

        % gyazz2md wikiname pagename > presentation.md
        % gist presentation.md

## gyazz2html

- Gyazz上のスライドデータをHTMLに変換します

        % gyazz2html -p wikiname pagename # slide.html生成
        % gyazz2html wikiname pagename    # TOC.html, page*.html生成

- テキストを変換するコマンドもあります
        
		% text2html -p {textfile}
		% text2html {textfile}
		

