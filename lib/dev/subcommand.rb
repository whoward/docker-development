
# Subcommand fixes naming in the auto-generated help for Thor subcommands
# see: https://github.com/erikhuda/thor/issues/261
class Subcommand < Thor
  def self.banner(command, _namespace = nil, _subcommand = false)
    "#{basename} #{subcommand_prefix} #{command.usage}"
  end

  def self.subcommand_prefix
    name.gsub(/.*::/, '')
        .gsub(/^[A-Z]/) { |match| match[0].downcase }
        .gsub(/[A-Z]/) { |match| "-#{match[0].downcase}" }
  end
end
