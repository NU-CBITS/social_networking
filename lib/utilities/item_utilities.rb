# A set of utility methods dealing with 'items'
# @author Eric Schlange <eric.schlange@northwestern.edu>
module ItemUtilities

  # Retrieve the class represented by the item's type
  def class_from_item_type(item_type_string)
    item_type_string.split("::").inject(Object) do  |mod, class_name|
      mod.const_get(class_name)
    end
  end

end