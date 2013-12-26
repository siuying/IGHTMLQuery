class XMLNodeSet
  attr_reader :native

  def initialize(native)
    @native = native
  end

  def count
    %x{#@native.count()}
  end

  def all_objects
    %x{#@native.allObjects()}
  end
  alias_method :nodes, :all_objects

  def first_object
    %x{#@native.firstObject()}
  end
end