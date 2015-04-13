/** @jsx React.DOM */
var Event = React.createClass({
  render: function () {
    return (
      <div class="event">
        <h1 className="eventName">
          {this.props.name}
        </h1>
        <h3 className="eventStart">
          {this.props.start}
        </h3>
        <h3 className="eventLocation">
          {this.props.location}
        </h3>
        <h3 className="eventDescription">
          {this.props.description}
        </h3>
      </div>
      );
  }
});

var ready = function () {
  React.render(
    <Event name="Nature Walk" start='3-Apr-2015' location='Yosemite' description="Walk through a forest!"/>,
    document.getElementById('events')
  );
};

$(document).ready(ready);
