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

end