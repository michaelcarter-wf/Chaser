var Reflux = require('reflux');

var Actions = Reflux.createActions([
	"refresh",
	"showOnlyActionNeeded",
	"newList",
	'showActionNeeded'
]);

module.exports = Actions;