File.open('/mnt/h/orgNote/wtt.txt').each do |l|
  if l.match /.*wtt.*/
    print "#{$.}  #{l}"
  end
end
