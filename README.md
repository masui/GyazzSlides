# GyazzSlide

<a href="http://Gyazz.com/">Gyazz</a>のデータからスライドを作るシステム

- **gyazz2html**
- **gyazz2md**

## gyazz2md

- Gyazz上のスライドデータをMarkdownに変換します
- <a href="http://glide.so/">glide.so</a> で利用できます
- Gyazzデータを取得するgyazzコマンドは<a href="http://GitHub.com/masui/ghazz-ruby">gyazz-ruby</a>に含まれています

        % gyazz wikiname pagename | gyazz2md > presentation.md
        % gist presentation.md
        % (glide.so上でインポート)

- <a href="https://github.com/ymrl/mdslide">mdslide</a>でも利用できるかも?        

## gyazz2html

- Gyazz上のスライドデータをHTMLに変換します
- 起動ディレクトリにいろんなHTMLファイルができるので注意

        % gyazz wikiname pagename | gyazz2html -p # 印刷用のslide.html生成
        % gyazz wikiname pagename | gyazz2html    # TOC.html, page*.html生成

		

