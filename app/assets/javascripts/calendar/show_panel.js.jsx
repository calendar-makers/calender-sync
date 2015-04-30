/** @jsx React.DOM */
var Event = React.createClass({
  render: function() {
    return (
      <div>
        <div id="image">
          <i>image resizing has to be done, maybe to resize along with page size?</i>
          {/* image here */}
        </div>
        <br/>

        <div id="name">
          <div className="left">
            <p>What</p>
          </div>
          <div className="right">
            <p>
              {this.props.title}
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
        <br/>
        <br/>

        <div id="rsvp">
          <i>rsvp under construction</i>
          {/* maybe we should put a link to an rsvp form page or popup... */}
        </div>
        <br/>
        <br/>
      </div>
    );
  }
});

var AdminButtons = React.createClass({
  handleDelete: function(e) {
<<<<<<< HEAD
    e.preventDefault();
    e.stopPropagation();
=======
    e.stopPropagation();
    e.preventDefault();
>>>>>>> e03d79783ab4b82067ce356a1c972ab695b08d12
    $.ajax({
      url: '/events/' + this.props.calEvent.id,
      type: 'DELETE',
      success: function(data) {
        React.render(
          <p id='deleteMsg'>{this.props.calEvent.title} was successfully removed.</p>,
          document.getElementById('panel')
        );
        $('#calendar').fullCalendar('removeEvents', this.props.calEvent.id);
      }.bind(this),
      error: function(xhr, status, err) {
        console.error('/events/' + this.props.calEvent.id, status, err.toString());
      }.bind(this)
    });
  },

  render: function() {
    return (
      <div>
        <i>these buttons will only be visible to admin</i>
        <div>
          <button id='edit_event' className='button' style={{float:'left'}} value='edit'/>
          <form onSubmit={this.handleDelete}>
            <input id='delete_event' className='button' style={{float: 'right'}} type='submit' value='Delete'/>
          </form>
        </div>
      </div>
    );
  }
});
