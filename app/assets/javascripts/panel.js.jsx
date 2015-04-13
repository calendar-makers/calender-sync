/** @jsx React.DOM */
var base = function() {
  return (
    <div>
      <h2 style={{fontWeight: 200}}>Event Details</h2>
      <p>Click an event!</p>
    </div>
  )
}

var show = function() {
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
            {this.props.name}
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
            {this.props.start}
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
            {this.props.location}
          </p>
          <p>
            <i>map may be coming soon!</i>
          </p>
        </div>
        <div style={{clear: 'both'}}></div>
      </div>
      <br/>  
      <div id="description">
        {this.props.description}
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
  );
}

var Event = React.createClass({
  render: show
});

var ready = function() {
  React.render(
    <Event name="Nature Walk" start='3-Apr-2015' location='Yosemite' description="Walk through a forest!"/>,
    document.getElementById('panel')
  );
};

$(document).ready(ready);
