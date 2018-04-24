# == Class: duo_unix
#
# Core class for duo_unix module
#
# === Authors
#
# Mark Stanislav <mstanislav@duosecurity.com>
class duo_unix (
  $usage = '',
  $ikey = '',
  $skey = '',
  $host = '',
  $group = '',
  $http_proxy = '',
  $fallback_local_ip = 'no',
  $failmode = 'safe',
  $pushinfo = 'no',
  $autopush = 'no',
  $motd = 'no',
  $prompts = '3',
  $accept_env_factor = 'no',
  $manage_ssh = true,
  $pam_unix_control = 'requisite',
  $pam_primary_module = 'pam_unix.so',
  $package_version = 'installed',
) {
  if $ikey == '' or $skey == '' or $host == '' {
    fail('ikey, skey, and host must all be defined.')
  }
  case $::operatingsystem {
    'Amazon': {
      $duo_package = 'duo_unix'
      $ssh_service = 'sshd'
      $gpg_file = '/etc/pki/rpm-gpg/RPM-GPG-KEY-DUO'
      $pam_file = '/etc/pam.d/password-auth'
      $pam_module = '/lib64/security/pam_duo.so'

      include duo_unix::yum
      include duo_unix::generic
    }
    default: {
      fail("Module ${module_name} does not support ${::operatingsystem}")
    }
  }

  if $usage == 'login' {
    include duo_unix::login
  } elsif $usage == 'pam' {
    include duo_unix::pam
  } else {
    fail('You must configure a usage of duo_unix, either login or pam.')
  }
}
