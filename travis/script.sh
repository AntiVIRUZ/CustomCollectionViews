if ["${TRAVIS_EVENT_TYPE}" == "cron"]; then
	fastlane ios betadev
else
	fastlane ios build
fi