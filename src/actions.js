var Reflux = require('reflux');

var Actions = Reflux.createActions([
	"refresh",
	"showOnlyActionNeeded",
	"newList",
	'showActionNeeded',
	"switchTo",
	"hidePR"
]);

module.exports = Actions;