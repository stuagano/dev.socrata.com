link_dir := $(shell mktemp -d /tmp/linkdoc.XXXX)

# Builds SASS->CSS, compiles the site, and ensures that search.json is updated
# If you've changed content, always commit search.json
all:
	sass sass/local.sass:css/local.css common/sass/common.sass:common/css/common.css
	-rm search.json
	jekyll build
	cp public/search.json search.json
	-git add search.json
	-terminal-notifier -title "Jekyll" -message "Build complete."
	-tput bel

# Builds the site and runs linklint to check for bad links
test: all
	linklint -doc ${link_dir} -root public /@
	open ${link_dir}/index.html

# Builds sass locally directly to ./public so you con't have to run a full jekyll build when hacking sass
sasslocal:
	sass --watch sass/local.sass:public/css/local.css common/sass/common.sass:public/common/css/common.css

# Copies JS resources locally so you don't have to do a full jekyll build when hacking JS
jslocal:
	cp js/* public/js/
	cp common/js/* public/common/js/
	cp foundry/template.mst public/foundry/

# Pushes updated taglines file. Since this requires my password, you (probably) can't run it...
taglines:
	curl --user chris.metcalf@socrata.com -X PUT --data @taglines.json --header "Content-type: application/json" --header "X-App-Token: bjp8KrRvAPtuf809u1UXnI0Z8" https://soda.demo.socrata.com/resource/etih-7ix2.json

