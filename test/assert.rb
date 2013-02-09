$ok_test = 0
$ko_test = 0
$kill_test = 0
$asserts  = []
$test_start = Time.now if Object.const_defined?(:Time)

##
# Create the assertion in a readable way
def assertion_string(err, str, iso=nil, e=nil)
  msg = "#{err}#{str}"
  msg += " [#{iso}]" if iso && iso != ''
  msg += " => #{e.message}" if e
  msg += " (mrbgems: #{GEMNAME})" if Object.const_defined?(:GEMNAME)
  msg
end

##
# Verify a code block.
#
# str : A remark which will be printed in case
#       this assertion fails
# iso : The ISO reference code of the feature
#       which will be tested by this
#       assertion
def assert(str = 'Assertion failed', iso = '')
  print(str, iso, ' : ') if $verbose
  begin
    $mrbtest_str, $mrbtest_iso = str, iso
    $mrbtest_assert = []
    if(!yield || $mrbtest_assert.size > 0)
      msg = assertion_string('Fail: ', str, iso, nil)
      $mrbtest_assert.each do |diff|
        msg += "\n" + diff.join("\n")
      end
      $asserts.push(msg)
      $ko_test += 1
      print('F')
    else
      $ok_test += 1
      print('.')
    end
  rescue Exception => e
    $asserts.push(assertion_string('Error: ', str, iso, e))
    $kill_test += 1
    print('X')
  ensure
    $mrbtest_assert = nil
  end
  print("\n") if $verbose
end

def assertion_diff(exp, act)
  msg = ""
  msg += "    Expected: #{exp.inspect}\n"
  msg += "      Actual: #{act.inspect}"
end

def assert_true(ret, msg = '', diff = '')
  if $mrbtest_assert
    if !ret
      $mrbtest_assert.push([msg, diff])
    end
  else
    if !ret
      $ko_test += 1
      $asserts.push(assertion_string('Fail: ', 'Assertion Failed') + "\n" + diff)
      print('F')
    else
      $ok_test += 1
      print('.')
    end
  end
  ret
end

def assert_equal(exp, act, msg = '')
  str = " - Fail: #{$mrbtest_str}"
  str += " [#{$mrbtest_iso}]" if $mrbtest_iso && $mrbtest_iso != ''
  str += " ... #{msg}" if msg && msg != ''
  str += " (mrbgems: #{GEMNAME})" if Object.const_defined?(:GEMNAME)
  diff = assertion_diff(exp, act)
  assert_true(exp == act, str, diff)
end

def assert_nil(obj, msg = nil)
  msg = "Expected #{obj.inspect} to be nil" if !msg
  assert_true(obj.nil?, msg)
end

##
# Report the test result and print all assertions
# which were reported broken.
def report()
  print "\n"

  $asserts.each do |msg|
    puts msg
  end

  $total_test = $ok_test.+($ko_test)
  print('Total: ')
  print($total_test)
  print("\n")

  print('   OK: ')
  print($ok_test)
  print("\n")
  print('   KO: ')
  print($ko_test)
  print("\n")
  print('Crash: ')
  print($kill_test)
  print("\n")

  if Object.const_defined?(:Time)
    print(' Time: ')
    print(Time.now - $test_start)
    print(" seconds\n")
  end
end

##
# Performs fuzzy check for equality on methods returning floats
# on the basis of the Math::TOLERANCE constant.
def check_float(a, b)
  tolerance = Math::TOLERANCE
  a = a.to_f
  b = b.to_f
  if a.finite? and b.finite?
    (a-b).abs < tolerance
  else
    true
  end
end
