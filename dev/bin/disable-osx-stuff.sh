#!/usr/bin/env bash
called=$_
if [[ $called != $0 ]] ; then
    echo "${BASH_SOURCE[@]} is being sourced."
else
    this_file=`basename "$0"`
    echo "$this_file is being run."
fi

function disable_agent {
  echo "Disabling ${1}"
  launchctl unload -w /System/Library/LaunchAgents/${1}.plist
}

disable_agent com.apple.AddressBook.SourceSync
disable_agent com.apple.AirPlayUIAgent
disable_agent com.apple.AOSHeartbeat
disable_agent com.apple.AOSPushRelay
disable_agent com.apple.bird
disable_agent com.apple.CalendarAgent
disable_agent com.apple.CallHistoryPluginHelper
disable_agent com.apple.CallHistorySyncHelper
disable_agent com.apple.cloudd
disable_agent com.apple.cloudfamilyrestrictionsd-mac
disable_agent com.apple.cloudpaird
disable_agent com.apple.cloudphotosd
disable_agent com.apple.CoreLocationAgent
disable_agent com.apple.coreservices.appleid.authentication
disable_agent com.apple.EscrowSecurityAlert
disable_agent com.apple.findmymacmessenger
disable_agent com.apple.gamed
disable_agent com.apple.helpd
disable_agent com.apple.icloud.fmfd
disable_agent com.apple.idsremoteurlconnectionagent
disable_agent com.apple.imagent
disable_agent com.apple.IMLoggingAgent
disable_agent com.apple.locationmenu
disable_agent com.apple.notificationcenterui
disable_agent com.apple.pbs
disable_agent com.apple.rtcreportingd
disable_agent com.apple.SafariCloudHistoryPushAgent
disable_agent com.apple.safaridavclient
disable_agent com.apple.SafariNotificationAgent
disable_agent com.apple.security.cloudkeychainproxy
disable_agent com.apple.SocialPushAgent
disable_agent com.apple.syncdefaultsd
disable_agent com.apple.telephonyutilities.callservicesd

function disable_daemon {
  echo "Disabling ${1}"
  sudo launchctl unload -w /System/Library/LaunchDaemons/${1}.plist
}

disable_daemon com.apple.apsd
disable_daemon com.apple.AssetCacheLocatorService
disable_daemon com.apple.awacsd
disable_daemon com.apple.awdd
disable_daemon com.apple.CrashReporterSupportHelper
disable_daemon com.apple.GameController.gamecontrollerd
disable_daemon com.apple.SubmitDiagInfo
disable_daemon com.apple.TMCacheDelete
