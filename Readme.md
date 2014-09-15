To use it simply instantiate a crawler with a seed domain and call execute

    crawler = Crawler.new('http://bankpossible.com')
    json_site_map = crawler.json_output(crawler.execute) 
    

Used a few libraries,  rspec and fakeweb for testing, nookogiri for parsing the web pages

Gone with the assumption that for a single domain this is okay to do all in memory.  
Obviously a fairly significant limitation of the design, but relatively simple to extend, simply
have the queues etc. act as caches and on a miss simply drop out to db/filesystem

I kind of got bogged down relearning rspec/ruby as I've never used it much outside of a few minor personal projects a 
couple  of years ago.  
It meant I rushed the crawler implementation a little bit to get the solution across today you'll notice
it's not tested as extensively as the rest of the code which I'm not happy with.  
Also as it's single threaded it's obviously not the most efficient solution, crawlers are a great candidate for 
producer/consumer pattern to get some improvement on a single machine, and from there it should be possible to
horizontally scale. Probably would have gone down the multi threading route if I'd done it in Java.

Only capturing css + images for now in the static assets, trivial to add anything via filters in Page object.

Other things to consider
- I'd probably want to make the filtering process more dynamic by passing in an collection of filters that can be executed to the PageLinkProcessor rather than just a list of urls
- probably want to add some sort of throttling, at the moment it'll just blindy go on and hammer a server that's not responding
- robots.txt if you want to be nice
- The page object is immutable, however the Sets for the assets + links are not
- The crawler can't really be reused on multiple domains, you have to create a new one at the moment
