data = File.open('alumnos-notas.csv', 'r')

def hsh_mk(inf)
  ary = []
  ind = []
  inf.each_line do |x, i = 0|
    i += 1
    instance_variable_set("@v#{i}", x).chomp!
    instance_variable_set("@l#{i}", instance_variable_get("@v#{i}").split(', '))
    ary.push(instance_variable_get("@l#{i}"))
    ind.push(instance_variable_get("@l#{i}").shift)
  end
  ind.zip(ary).to_h
end

hsh = hsh_mk(data)

prom = {}
hsh.each do |ind, x|
  n = 0
  x.inject(0) do |m, i|
    m += i.to_i unless i.to_i == 'A'
    n = m
  end
  prom[ind] = (n.to_f / x.count)
end

inas = {}
hsh.each do |ind, x|
  n = 0
  x.inject(0) do |m, i|
    m += 1 if i == 'A'
    n = m
  end
  inas[ind] = n
end

def aprobado(ary, nota = 5)
  print "\nAlumnos aprobados:\n"
  ary.each { |ind, x| puts ind if x.to_i >= nota }
end

opcion = 0

while opcion != 4
  print "\nMenú de Opciones:\n"
  print "1: Generar archivo con nombre de cada alumno y su promedio de notas.\n"
  print "2: Ver inasistencias totales\n3: Mostrar alumnos aprobados\n"
  print "4: Salir\n\nSeleccione una opcion del menu\n\n"
  opcion = gets.chomp.to_i

  case opcion
  when 1
    f = File.new('promedios.csv', 'w')
    File.open('promedios.csv', 'w') { prom.each { |i, x| f.puts "#{i}: #{x}" } }
    print "\nArchivo generado con éxito\n"
  when 2
    inas.each { |ind, _or_x| print "Inasistencias de #{ind}: #{inas[ind]}\n" }
    suma = 0
    inas.each { |_or_x, y| suma += y }
    print "\nInasistencias totales del grupo: #{suma}\n"
  when 3
    print "\nLa nota por defecto para ser aprobado es 5, ¿desea modificarla?\n"
    print '(si/no)'
    answer = gets.chomp
    if answer == 'si'
      print "\nIngrese ahora la nueva nota para aprobar\n"
      n_nota = gets.chomp.to_i
      aprobado(prom, n_nota)
    elsif answer == 'no'
      aprobado(prom)
    else
      print "\nIntentelo otra vez\n"
      print "\nLa nota por defecto de aprobación es 5, ¿desea modificarla?\n"
      print '(si/no)'
      answer = gets.chomp.downcase!
    end
  when 4
    print "\n\nSaliendo...\n\n"
  else
    print "\nVuelva a intentarlo\n\nMenú de Opciones:\n"
    print "1: Generar archivo con nombre de cada alumno y promedio de notas.\n"
    print "2: Ver inasistencias totales\n3: Mostrar alumnos aprobados\n"
    print "4: Salir\n\nSeleccione una opcion del menu\n\n"
    opcion = gets.chomp.to_i
  end
end
