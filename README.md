# GyazzSlide

Gyazzデータからスライドを作るシステム

- gyazz2html
- gyazz2md

## gyazz2md

- Gyazz上のスライドデータをMarkdownに変換します
- <a href="http://glide.so/">glide.so</a> で利用できます

        % gyazz2md wikiname pagename > presentation.md
        % gist presentation.md
        % (glide.so上でインポート)

## gyazz2html

- Gyazz上のスライドデータをHTMLに変換します

        % gyazz2html -p wikiname pagename # 印刷用のslide.html生成
        % gyazz2html wikiname pagename    # TOC.html, page*.html生成

- テキストからHTMLを変換することもできます
        
		% text2html -p {textfile}
		% text2html {textfile}
		

