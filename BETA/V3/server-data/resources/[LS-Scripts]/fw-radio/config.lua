Config = Config or {}

Config.MaxFrequency = 500

Config.CanJoinFrequentie = true

Config.RestrictedChannels = {
  [1] = {
    police = true
  },
  [2] = {
    police = true
  },
  [3] = {
    ambulance = true
  },
  [4] = {
    ambulance = true
  },
  [5] = {
    police = true,
    ambulance = true
  }
} 