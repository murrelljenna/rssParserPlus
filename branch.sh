#!/bin/bash

SRC="http://www.rssmix.com/u/8228213/rss.xml"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

if [ ! -d "episodes" ]; then
	mkdir "episodes"
fi

if [ ! -f "oldurls" ]; then
  touch oldurls
fi

wget -O "$DIR/rss.xml" $SRC
egrep -o 'https://.*\.mp3' rss.xml | grep -v 'teaser' | sort --unique > urls
diff urls oldurls | egrep -o 'https://.*\.mp3' > buf

# Output into 'buf' then redirect to urls. Was having trouble
# directly outputing to urls.

cat buf > urls
rm buf

# Read file urls and download resources

wget -i urls -w240 --random-wait

mv ~/*.mp3 $DIR/episodes/
cat urls >> oldurls
