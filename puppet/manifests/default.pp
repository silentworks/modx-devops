class {"modx":}
class{"grunt::install":
    require => Exec['modx_git']
}
