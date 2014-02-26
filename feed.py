# Parse RSS feed and output javascripty json for graphing

import feedparser
from pprint import pprint

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

url = "http://johngriersonhasalottoanswerfor.blogspot.com/feeds/posts/default?alt=rss"
feed_data = feedparser.parse(url)
feed_entries = feed_data['entries']
feed_tags = feed_data['feed']['tags']

entries = map(extract_entry, feed_entries)
tags = map(extract_tag, feed_tags)

print "Posts: {}".format(len(entries))
print "Tags: {}".format(len(tags))
