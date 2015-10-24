import {Socket} from "deps/phoenix/web/static/js/phoenix";
import Reflux from "bower_components/reflux/dist/reflux";
import Actions from "../Actions";

export default Reflux.createStore({
  listenables: Actions,

  init() {
    this.connected = false;
    this._socket = new Socket("/gaze/ws");
    this._socket.connect();
    this._socket.onOpen(this.onSocketOpen);
    this._socket.onClose(this.onSocketClose);
    this._socket.onError(this.onSocketClose);
  },

  getInitialState() {
    return this;
  },

  onJoin(channelName) {
    var chan = this._socket.channel(channelName, {});

    chan.join().receive("ok", () => {
      Actions.joined(channelName, chan);
    });
  },

  onSocketOpen() {
    this.connected = true;
    this.trigger(this);
  },

  onSocketClose() {
    this.connected = false;
    this.trigger(this);
  }
});
