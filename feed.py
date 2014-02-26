# Parse RSS feed and output javascripty json for graphing

import feedparser
import json
from pprint import pprint

FEED_URL = "http://johngriersonhasalottoanswerfor.blogspot.com/feeds/posts/default?alt=rss"
WRITE_FILE = "blogdata.js"

def extract_tag(tag):
  return tag['term']

def extract_entry(entry):
  return {
    'title': entry['title'],
    'author': entry['author_detail']['name'],
    'link': entry['link'],
    'tags': map(extract_tag, entry['tags']) if 'tags' in entry else [],
    'summary': entry['summary'],
  }
  return entry

def write_to_file(filepath, entries, tags):
  data = {'entries': entries, 'tags': tags}
  with open(filepath, 'w') as datafile:
    json.dump(
      data, datafile,
      sort_keys=True, indent=4,
      separators=(',', ': ')
    )

feed_data = feedparser.parse(FEED_URL)
feed_entries = feed_data['entries']
feed_tags = feed_data['feed']['tags']

entries = map(extract_entry, feed_entries)
tags = map(extract_tag, feed_tags)

print "Posts: {}".format(len(entries))
print "Tags: {}".format(len(tags))

write_to_file(WRITE_FILE, entries, tags)
