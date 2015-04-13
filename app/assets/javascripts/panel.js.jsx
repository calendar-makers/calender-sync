/** @jsx React.DOM */
var Event = React.createClass({
  render: function() {
    return (
    <div>
      <h2 style={{fontWeight: 200}}>Event Details</h2>
      <div id="image">
        <i>image resizing has to be done, maybe to resize along with page size?</i>
        // image here
      </div>
      <br/>
      <div id="name">
        <div className="left">
          <p>What</p>
        </div>
        <div className="right">
          <p>
            Nature Walk
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <div id="date_time">
        <div className="left">
          <p>When</p>
        </div>
        <div className="right">
          <p>
            April 12, 2015 11:00am
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <div id="location">
        <div className="left">
          <p>Where</p>
        </div>
        <div className="right">
          <p>
            Yosemite
          </p>
          <p>
            <i>map may be coming soon!</i>
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <br/>  
      <div id="description">
        Walk through a forest.
      </div>
      <br/>
      <br/>
      <div id="rsvp">
        <i>rsvp under construction</i>
        // maybe we should put a link to an rsvp form page or popup...
      </div>
      <br/>
      <br/>
      <div id="crud"></div>
      /* if @current user, then show edit and delete button */
    </div>
    )}
  });

var ready = function() {
  React.render(
    <Event name="Nature Walk" start='3-Apr-2015' location='Yosemite' description="Walk through a forest!"/>,
    document.getElementById('panel')
  );
};

$(document).ready(ready);
