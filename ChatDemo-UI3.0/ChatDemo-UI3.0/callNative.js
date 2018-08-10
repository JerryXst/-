iOS = {
        schema: 'callnative',
        functionList:{
            callAudio: 'callAudio',
            callVideo: 'callVideo'
        },
        callNative: function (cmd, peerID) {
            document.location.href = this.schema +'://' + cmd + '?peerID=' + peerID;
    } 
};
