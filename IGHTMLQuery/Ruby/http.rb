module IGHTMLQuery
  module HTTP
    def self.get(url)
      %x{HTTPGet(url)}
    end
  end
end