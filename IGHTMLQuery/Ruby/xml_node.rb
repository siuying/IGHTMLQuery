class XMLNode
  include Native

  module Core
    include Native

    alias_native :tag, :tag
    alias_native :tag=, :setTag
    alias_native :text, :text
    alias_native :text=, :setText
    alias_native :xml, :xml
    alias_native :inner_xml, :innerXml
    alias_native :html, :html
    alias_native :inner_html, :innerHtml
  end
  include Core

  module Traversal
    def parent
      %x{
        var parent = #@native.parent();
        return (parent === undefined) ? Opal.NIL : #{XMLNode.new(`parent`)};
      }
    end

    def next_sibling
      %x{
        var nextSibling = #@native.nextSibling();
        return (nextSibling === undefined) ? Opal.NIL : #{XMLNode.new(`nextSibling`)};
      }
    end

    def previous_sibling
      %x{
        var previousSibling = #@native.previousSibling();
        return (previousSibling === undefined) ? Opal.NIL : #{XMLNode.new(`previousSibling`)};
      }
    end

    def children
      %x{
        var children = #@native.children();
        return (children === undefined) ? Opal.NIL : #{XMLNodeSet.new(`children`)};
      }
    end

    def first_child
      %x{
        var firstChild = #@native.firstChild();
        return (firstChild === undefined) ? Opal.NIL : #{XMLNode.new(`firstChild`)};
      }
    end
  end
  include Traversal

  module Attribute
    def []=(name, value)
      %x{#@native.setAttributeValue(name, value)}
    end

    def [](name)
      %x{
        var attribute = #@native.attribute(name);
        return (attribute === undefined) ? Opal.NIL : attribute;
      }
    end

    def attributes
      %x{
        var names = #@native.attributeNames();
        return (names === undefined) ? Opal.NIL : names;
      }
    end
  end
  include Attribute
                     
  module Query
    def xpath(query)
      set = %x{#@native.queryWithXPath(query)}
      XMLNodeSet.new(set)
    end
    def css(query)
      set = %x{#@native.queryWithCSS(query)}
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