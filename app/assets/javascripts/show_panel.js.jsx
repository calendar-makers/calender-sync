/** @jsx React.DOM */
var defaultPage = function() {
  return (
    <p>Click an event!</p>
  )
}

var Event = React.createClass({
  render: function() {
    return (
      <div>
        <h2 style={{fontWeight: 200}}>{this.props.name}</h2>
        <div id="image">
          <i>image resizing has to be done, maybe to resize along with page size?</i>
          // image here
        </div>
        <br/>
        <div id="date_time">
          <div className="left">
            <p>When</p>
          </div>
          <div className="right">
            <p>
              {this.props.timePeriod}
            </p>
          </div>
          <div style={{clear: 'both'}}></div>
        </div>
        <div id="location">
          <div className="left">
            <p>Where</p>
          </div>
          <div className="right" style={{whiteSpace: 'pre-wrap'}}>
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
        <div id="description" dangerouslySetInnerHTML={{__html: this.props.description}}/>
      </div>
    );
  }
});

var AdminButtons = React.createClass({
  loadEventsFromServer: function() {
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      success: function(events) {
        this.setState({events: events});
        React.render(
          <div>NOT YET READY</div>,
          document.getElementById('panel')
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  handleEventDelete: function(event) {
    var events = this.state.events;
    var reducedEvents = events.concat([event]);
    this.setState({events: reducedEvents});
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'DELETE',
      data: {'event': event},
      success: function(data) {
        React.render(
          <p>Click an event!</p>,
          document.getElementById('panel')
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  handleDelete: function() {
    this.props.onEventDelete({name: name, start: start, end: end});
    return false;
  },

  handleEventUpdate: function(event) {
    var events = this.state.events;
    var newEvents = events.concat([event]);
    this.setState({events: newEvents});
    $.ajax({
      url: this.props.url,
      dataType: 'json',
      type: 'PUT',
      data: {'event': event},
      success: function(data) {
        React.render(
          <div>NOT READY</div>
        );
      }.bind(this),
      error: function(xhr, status, err) {
        console.error(this.props.url, status, err.toString());
      }.bind(this)
    });
  },

  handleUpdate: function() {
  },

  render: function() {
    return (
      <table>
        <tr>
          <td>
            <form id='editEvent' onSubmit={this.handleEdit}>
              <input type='submit' value='Edit'/>
            </form>
          </td>
          <td>
            <form id='deleteEvent' onSubmit={this.handleDelete}>
              <input type='submit' value='Delete'/>
            </form>
          </td>
        </tr>
      </table>
    );
  }
});
