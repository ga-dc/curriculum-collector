source config.sh

echo "Downloading all repos to '/$TARGET_FOLDER'. This may take a minute..."
ruby .script.rb $INPUT_URL $TARGET_FOLDER $HTTPS_OR_SSH > .commands.sh
if [ "$1" = "dry" ]; then
  less .commands.sh
else
  sh .commands.sh
fi
echo "Done!"
