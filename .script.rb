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

if !(Dir.exists? target_folder)
  puts "mkdir #{target_folder}"
end
puts "ROOT_DIR=$(pwd)"
repos.each do |repo|
  puts "#"
  puts "echo '...#{repo[:title]}...'"
  path = repo[:path].join("/")
  is_new_dir = !(Dir.exists?(path))
  if is_new_dir
    puts "mkdir #{path}"
  end
  if repo[:url]
    puts "cd #{path}"
    if is_new_dir
      puts "git clone #{repo[:url]} ."
    else
      puts "git pull origin master"
    end
    puts "cd $ROOT_DIR"
  end
end
