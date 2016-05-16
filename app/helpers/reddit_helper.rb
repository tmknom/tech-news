module RedditHelper
  EMPTY = ''

  def embed_link(url)
    p uri = URI.parse(url)

    if uri.host.include?('imgur.com')
      if File.extname(uri.path) == '.gifv'
        data_id = File.basename(uri.path, '.*')
        result = "<blockquote class='imgur-embed-pub' lang='en' data-id='#{data_id}'>" +
            "<a href='//imgur.com/#{data_id}'>View post on imgur.com</a></blockquote>" +
            "<script async src='//s.imgur.com/min/embed.js ' charset='utf-8'></script>"
        return result
      end

      gallery_regexp = %r{/gallery/(.+)$}
      if uri.path =~ gallery_regexp
        data_id = uri.path.match(gallery_regexp)[1].delete('/')
        return "<a href='#{url}'><img data-original='//imgur.com/#{data_id}.gif' class='lazy' width='560' style='margin-bottom:10px' /></a>"
      end

      a_regexp = %r{/a/(.+)$}
      if uri.path =~ a_regexp
        return "<a href='#{url}'><img data-original='http://capture.heartrails.com/400x600/cool?#{url}' class='lazy' width='400' style='margin-bottom:10px' /></a>"
      end

      data_id = uri.path.split('/').last
      return "<a href='#{url}'><img data-original='//imgur.com/#{data_id}.gif' class='lazy' width='560' width='400' style='margin-bottom:10px' /></a>"
    end

    if uri.host.include?('gfycat.com')
      data_id = uri.path.match(%r{/(.+)$})[1]
      result = "<iframe src='https://gfycat.com/ifr/#{data_id}' " +
          "frameborder='0' scrolling='no' width='560' height='560' allowfullscreen></iframe>"
      return result
    end

    if %w(.gif .jpg .png .jpeg).include?(File.extname(uri.path))
      return "<a href='#{url}'><img data-original='#{url}' class='lazy' width='560' style='margin-bottom:10px' /></a>"
    end

    "<a href='#{url}'>#{url}</a>"
  end

  def download_button(url)
    p uri = URI.parse(url)
    if uri.host.include?('imgur.com')
      data_id = File.basename(uri.path, '.*')
      return "<a class='btn btn-success' href='//imgur.com/download/#{data_id}'>download</a>"
    end

    EMPTY
  end

end
