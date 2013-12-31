class XMLNode
  attr_reader :native

  def initialize(native)
    @native = native
  end

  module Core
    def tag
      %x{#@native.tag()}
    end

    def tag=(tag)
      %x{
        #@native.setTag(tag)
        return #@native.tag()
      }
    end

    def text
      %x{#@native.text()}
    end

    def text=(text)
      %x{
        #@native.setText(text)
        return #@native.text()
      }
    end

    def xml
      %x{#@native.xml()}
    end

    def inner_xml
      %x{#@native.innerXml()}
    end

    def last_error
      %x{#@native.lastError()}
    end

    def remove_namespaces
      %x{#@native.removeNamespaces()}
    end
  end
  include Core

  module Traversal
    def parent
      XMLNode.new(%x{#@native.parent()})
    end

    def next_sibling
      XMLNode.new(%x{#@native.nextSibling()})
    end

    def previous_sibling
      XMLNode.new(%x{#@native.previousSibling()})
    end

    def children
      XMLNodeSet.new(%x{#@native.children()})
    end

    def first_child
      XMLNodeSet.new(%x{#@native.firstChild()})
    end

    def unique_key
      XMLNodeSet.new(%x{#@native.uniqueKey()})
    end
  end
  include Traversal

  module Attribute
    def []=(name, value)
      %x{#@native.setAttributeValue(name, value)}
    end

    def [](name)
      %x{#@native.attribute(name)}
    end

    def attributes
      %x{#@native.attributeNames()}
    end
  end
  include Attribute
                     
  module Query
    def xpath(query)
      set = %x{#@native.queryWithXPath(query)}
      XMLNodeSet.new(set)
    end
  end
  include Query

  module Manipulation
    def append(child)
      %x{#@native.appendWithNode(child)}
      self
    end

    def add_child(child)
      %x{#@native.addChildWithNode(child)}
      self
    end

    def add_next_sibling(sibling)
      %x{#@native.addNextSiblingWithNode(sibling)}
      self
    end

    def add_previous_sibling(sibling)
      %x{#@native.addPreviousSiblingWithNode(sibling)}
      self
    end

    def append_with_xml(xml)
      %x{#@native.appendWithXMLString(xml)}
      self
    end

    def prepend_with_xml(xml)
      %x{#@native.prependWithXMLString(xml)}
      self
    end

    def add_child_with_xml(xml)
      %x{#@native.addChildWithXMLString(xml)}
      self
    end

    def add_next_sibling_with_xml(xml)
      %x{#@native.addNextSiblingWithXMLString(xml)}
      self
    end

    def add_previous_sibling_with_xml(xml)
      %x{#@native.addPreviousSiblingWithXMLString(xml)}
      self
    end

    def empty
      %x{#@native.empty()}
      self
    end

    def remove
      %x{#@native.remove()}
      self
    end
  end
  include Manipulation

end