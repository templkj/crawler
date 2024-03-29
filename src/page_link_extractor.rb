class PageLinkExtractor

  def initialize(urlsToFilter)
    @urlsToFilter = urlsToFilter
  end

  def extract_page_links_within_given_domain(downloadedPage, downloadedFromLink)
    queue = Set.new

    downloadedPage.links.each do |linkOnPage|

      downloadedPageUri = URI(downloadedFromLink)
      linkOnPageUri = reconstruct_relativeUrl(downloadedPageUri, linkOnPage)

      if (is_to_be_processed?(downloadedPageUri, linkOnPageUri))
        linkString = linkOnPageUri.to_s
        queue << linkString
      end

    end

    queue
  end

  private
  def reconstruct_relativeUrl(uriContainingHost, linkString)
    begin
      newLinkUri = URI(linkString)
      if !newLinkUri.host
        reconstructedUri = URI(uriContainingHost.scheme + '://' + uriContainingHost.host)
        newLinkUri = URI.join(reconstructedUri, linkString)
      end
      newLinkUri
    rescue
      warn "Unable to parse link:#{linkString} on page #{uriContainingHost}"
      uriContainingHost
    end

  end


  def is_to_be_processed?(downloadedPageUri, linkOnPageUri)
    (linkOnPageUri.host == downloadedPageUri.host) &&
        (linkOnPageUri.scheme == downloadedPageUri.scheme) &&
        (!@urlsToFilter.include? linkOnPageUri.to_s)
  end
end