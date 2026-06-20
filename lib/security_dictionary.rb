# lib/security_dictionary.rb
module SecurityDictionary
  WORDS = [
    "password", "letmein", "qwerty", "dictionary",
    "security", "hacker", "breach", "attack",
    "cipher", "encrypt", "decode", "firewall",
    "malware", "trojan", "virus", "ransomware",
    "phishing", "spoofing", "hijacking", "exploit",
    "vulnerability", "payload", "backdoor", "shellcode",
    "injection", "overflow", "buffer", "memory",
    "stack", "heap", "pointer", "reference",
    "network", "packet", "socket", "protocol",
    "routing", "gateway", "proxy", "tunnel"
  ].freeze

  # 4th word (index 3): "dictionary"
  # 5th word (index 4): "security"
  # Erika's password is complex and not in dictionary
end
