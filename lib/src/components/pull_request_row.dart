library src.components.pull_request_row;

import 'dart:core';
import 'dart:html';

import 'package:intl/intl.dart';
import 'package:react/react.dart' as react;
import 'package:web_skin_dart/ui_components.dart';
import 'package:web_skin_dart/ui_core.dart' show Dom;
import 'package:chrome/chrome_ext.dart' as chrome;

import 'package:wChaser/src/models/models.dart';

var mediaWidth = {'width': '70%'};

var PullRequestRow = react.registerComponent(() => new _PullRequestRow());

class _PullRequestRow extends react.Component {
  GitHubPullRequest get pullRequest => props['pullRequest'];

  openNewTab(_) {
//      chrome.tabs.create(new chrome.TabsCreateParams(url:pullRequest.htmlUrl));
    window.open(pullRequest.htmlUrl, pullRequest.id.toString());
  }

  removeThisGuy(_) {}

  renderImage() {
    String actionNeededClass = '';
    if (pullRequest.actionNeeded) {
      actionNeededClass = 'action-needed-img';
    }

    return react.span(
        {'className': 'pull-left', 'onClick': openNewTab},
        react.img(
            {'className': 'media-object avatar-image', 'src': pullRequest.githubUser.avatarUrl, 'alt': 'avatar_url'}));
  }

  renderTitle() {
    _formatDate();
    return (Dom.div()
      ..className = 'media-body pull-left'
      ..style = mediaWidth
      ..onClick = openNewTab)([
      (Dom.small()..className = 'small-text create-date')((Dom.em())(pullRequest.fullName)),
      (Dom.h6()..className = 'media-heading')([
        pullRequest.title,
        (Dom.br())(),
        (Dom.small()..className = 'small-text')(pullRequest.updatedAtPretty,
            (Dom.span()..className = 'red')(pullRequest.actionNeeded ? ' Action Needed' : ''))
      ])
    ]);
  }

  // TODO break this into a helper to prettify it
  _formatDate() {
    DateTime moonLanding = DateTime.parse(pullRequest.updatedAt); // 8:18pm
    var formatter = new DateFormat('MM.dd.yyyy');
    return formatter.format(moonLanding);
  }

//  <div className="media">
//			  <div className="media-body pull-left" style={mediaWidth} onClick={this.openNewTab}>
//			  		<small className="small-text created-date"><em>{pr.base.repo.full_name}</em></small>
//			    	<h6 className="media-heading">
//						{ pr.title } <br/>
//			    		<small className="small-text">
//			    			updated {moment.utc(pr.updated_at).fromNow()} <span style={badgeStyle}> {this.state.badgeText} {this.state.unread} </span>
//			    		</small>
//			    	</h6>
//			  </div>
//			  <div className='pull-right' onMouseOver={this.handleHover} onMouseOut={this.handleHover} onClick={this.removeThisGuy}><i className={redX}></i></div>
//			  <div className='pull-right'><small className='small-text'>{moment.utc(pr.created_at).format('MM/DD')} </small></div>
//			</div>

  render() {
    return react.div({
      'className': 'media chaser-row'
    }, [
      renderImage(),
      renderTitle(),
      react.div({'className': 'pull-right chaser-close-button', 'onClick': removeThisGuy},
          react.i({'className': 'close-x icon icon-sm icon-close close-x',}))
    ]);
  }
}
