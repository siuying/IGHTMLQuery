class XMLNode
  def initialize(native)
    @native = native
  end

  def tag
    `#@native.tag()`
  end

  def tag=(tag)
    `#@native.setTag(tag)`
  end

  def text
    `#@native.text()`
  end

  def text=(text)
    `#@native.setText(text)`
  end

  def xml
    `#@native.xml()`
  end

  def inner_xml
    `#@native.innerXml()`
  end

  def last_error
    `#@native.lastError()`
  end

  def remove_namespaces!
    `#@native.removeNamespaces()`
  end
end