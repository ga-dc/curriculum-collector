require "httparty"

input_url = ARGV[0]
target_folder = ARGV[1]

rx = {
  looks_like_prose: /(^[a-zA-Z])|(^\#[^\#])|(^[0-9][^\.])/,
  url: /(?<=\]\()[^\)]+(?=\))/,
  url_title: /(?<=\[)[^\]]+(?=\])/,
  newline_punct: /^[^\w]+/,
  non_alphanum: /[^a-z0-9\-\s]/,
  mult_hyphens: /-{1,}/,
  final_slash: /\/{1,}$/,
  blank: /^\s*$/
}

levels = []
repos = []
HTTParty.get(input_url).split(/[\n\r]/).each do |line|
  next if (line =~ rx[:blank] || line =~ rx[:looks_like_prose])
  level = line.size - line.lstrip.size
  levels.push(level)
  url = line.match(rx[:url]){|m| m.to_s}
  if url then url.gsub!(rx[:final_slash], "") end
  title = line.gsub(rx[:url], "").strip
  title = line.match(rx[:url_title]){|m| m.to_s} || line.gsub(rx[:newline_punct], "")
  title = title.downcase.strip
  title.gsub!(rx[:non_alphanum], "")
  title.gsub!(/\s/, "-")
  title.gsub!(rx[:mult_hyphens], "-")
  repos.push({level: level, title: title, url: url, raw: line})
end

path = [target_folder]
prev_level = 0
levels = levels.uniq.sort
repos.each do |repo|
  level = levels.index(repo[:level])
  path = path[0..level]
  path.push(repo[:title])
  prev_level = level
  repo[:path] = path.dup
end

puts "date"
puts "rm -rf #{target_folder}"
puts "mkdir #{target_folder}"
repos.each do |repo|
  puts "#"
  if repo[:url]
    base = repo[:url].match(/(?<=\/)[\w-]+$/){|m| m.to_s}
    parent = repo[:path][0..-2].join("/")
    puts "curl -s --location #{repo[:url]}/archive/master.zip > #{base}.zip"
    puts "unzip #{base}.zip"
    puts "rm #{base}.zip"
    puts "mv #{base}-master/ #{repo[:path].join("/")}/"
  else
    puts "mkdir #{repo[:path].join("/")}"
  end
end
