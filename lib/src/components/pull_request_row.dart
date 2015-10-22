library src.components.pull_request_row;

import 'dart:core';
import 'dart:html';

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

  removeThisGuy(_) {

  }

  renderImage() {
    return (Dom.span()
      ..className = 'pull-left'
      ..onClick = openNewTab)
    ((Dom.img()
      ..className = 'media-object avatar-image'
      ..src = pullRequest.githubUser.avatarUrl
      ..alt = 'avatar_url')()
    );
  }

  renderTitle() {
    return (Dom.div()
      ..className = 'media-body pull-left'
      ..style = mediaWidth
      ..onClick = openNewTab
    )
    ([
        (Dom.small()..className = 'smal-text create-date')
        ((Dom.em())(pullRequest.fullName)),
        (Dom.h6()..className = 'media-heading')
        ([
            pullRequest.title,
            (Dom.br())(),
            (Dom.small()..className = 'small-text')
            ('updated ${pullRequest.updatedAt}')
        ])
    ]);
  }

  _formatDate() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    String formatted = formatter.format(now);
    print(formatted); // something like 2013-04-20
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
    return (Dom.div()..className = 'media')
    ([
        renderImage(),
        renderTitle(),
        (Dom.div()
            ..className = 'pull-right'
            ..onClick = removeThisGuy
        )
        ([
            (Icon()
              ..glyph = IconGlyph.CLOSE
              ..size = IconSize.SMALL
              ..className = 'close-x'
            )()
        ])
    ]);
  }

}