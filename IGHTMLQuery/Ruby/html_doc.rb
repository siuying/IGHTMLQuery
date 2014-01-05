class HTMLDoc < XMLNode
  attr_reader :native

  def initialize(html)
    @native = `IGHTMLDocumentCreateWithHTML(#{html.to_n})`
  end
end