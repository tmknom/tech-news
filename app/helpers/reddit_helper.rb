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
    end

    if uri.host.include?('gfycat.com')
      data_id = uri.path.match(%r{/(.+)$})[1]
      result ="<div style='position:relative;padding-bottom:calc(100% / 1.78);margin-bottom:15px;'>" +
          "<iframe src='https://gfycat.com/ifr/#{data_id}' " +
          "frameborder='0' scrolling='no' width='100%' height='100%' style='position:absolute;top:0;left:0;' " +
          "allowfullscreen></iframe></div>"
      return result
    end

    if File.extname(uri.path) == '.gif'
      return "<a href='#{url}'><img src='#{url}' /></a>"
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
