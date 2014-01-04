class HTMLDoc < XMLNode
  attr_reader :native

  def initialize(html)
    @native = %x{IGHTMLDocument(html)}
  end
end