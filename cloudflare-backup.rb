#!/usr/bin/ruby
require 'cloudflare'

require 'json'
require 'pathname'
require 'set'

# Get all records, even if > 180 in number
def records(cf, zone)
  records = []
  loop do
    resp = cf.rec_load_all(zone, records.size)
    recset = resp['response']['recs']
    records.concat(recset['objs'])
    break unless recset['has_more']
  end
  records
end

def write_json(dir, filename, obj)
  path = dir.join(filename + '.json')
  IO.write(path.to_s, JSON.pretty_generate(obj))
  return path
end

def backup(cf, dir)
  # Fetch everything
  zones = cf.zone_load_multi
  recs = {}
  zones['response']['zones']['objs'].each do |zone|
    name = zone['zone_name']
    recs[name] = records(cf, name)
  end

  # Put it where it belongs
  dir = Pathname.new(dir)
  dir.mkpath
  written = Set.new
  written << write_json(dir, 'zones', zones)
  recs.each { |z, rs| written << write_json(dir, z + '.zone', rs) }

  # Remove old files
  dir.find do |file|
    next if dir == file
    file.unlink unless written.include? file
  end
end


email, token = ARGV
cf = CloudFlare::connection(token, email)
backup(cf, 'backup')
