assert('assert_includes') do
  assert_includes([1,2,3], 1)
  assert_includes([1,2,3], 5)
end

assert('assert_instance_of') do
  assert_instance_of(String, 'a')
  assert_instance_of(Object, 'a')
  assert_instance_of(Array, 'a')
end

assert('assert_kind_of') do
  assert_kind_of(String, 'a')
  assert_kind_of(Object, 'a')
  assert_kind_of(Array, 'a')
end

assert('assert_raises - not raised') do
  assert_raises(StandardError) do
    a = 1
  end
end

assert('assert_raises') do
  assert_raises(TypeError) do
    "1" + 1
  end
  assert_raises(ArgumentError) do
    "1" + 1
  end
end

