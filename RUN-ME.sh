source .config.sh

echo "Downloading all repos to '/$TARGET_FOLDER'. This may take a minute..."
ruby .script.rb $INPUT_URL $TARGET_FOLDER $HTTPS_OR_SSH > .commands.sh
sh .commands.sh
echo "Done!"
