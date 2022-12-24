export default {
    mounted() {
        this.el.scroll({ top: this.el.scrollHeight });
    },
    beforeUpdate() {
        this.scrolledToBottom = this.el.scrollTop === (this.el.scrollHeight - this.el.offsetHeight);
    },
    updated() {
        if (this.scrolledToBottom) {
            this.el.scroll({ top: this.el.scrollHeight, behavior: 'smooth' });
        }
    }
  };