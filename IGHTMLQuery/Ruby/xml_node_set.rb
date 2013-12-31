class XMLNodeSet
  attr_reader :native

  def initialize(native)
    @native = native
  end

  def count
    %x{#@native.count()}
  end

  def all
    %x{#@native.allObjects()}.collect {|node| XMLNode.new(node) }
  end
  alias_method :nodes, :all

  def first
    node = %x{#@native.firstObject()}
    XMLNode.new(node)
  end
end