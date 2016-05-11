module Media
  class MediaCommandRepository
    def save_if_not_exists(medium)
      unless Medium.exists?(url: medium.url, source_url: medium.source_url)
        medium.save
      end
    end
  end
end
