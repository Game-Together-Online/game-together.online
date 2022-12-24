export default {
    mounted() {
        this.el.addEventListener("keypress", event => {
            if (event.key === "Enter" && !event.shiftKey) {
                this.el.dispatchEvent(
                    new Event("submit", {bubbles: true, cancelable: true})
                );
                this.el.reset();
            }
        });
    }
};