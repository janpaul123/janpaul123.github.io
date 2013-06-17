jekyll build
git checkout master
cp -r _site/* . && rm -rf _site/ && touch .nojekyll
