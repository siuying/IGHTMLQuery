class XMLNodeSet
  include Enumerable

  attr_reader :native

  def initialize(native)
    @native = native
  end

  module Core
    def count
      %x{#@native.count()}
    end

    def all
      %x{#@native.allObjects()}.collect {|node| XMLNode.new(node) }
    end
    alias_method :nodes, :all

    def first
      node = %x{#@native.firstObject()}
      if node
        XMLNode.new(node)
      else
        nil
      end
    end

    def each
      all.each{ |obj| yield(obj) }
    end

    def text
      first ? first.text : nil
    end
  end
  include Core

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