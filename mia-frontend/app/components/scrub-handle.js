import Ember from 'ember';

export default Ember.Component.extend({
	classNames: ['scrub-handle'],
	fraction: 0,
	upperLimit: 1,
	lowerLimit: 0,
	fractionObserver: Ember.observer('fraction', function() {
		let containerWidth = this.$().parent().innerWidth() - 100;
		var leftPos = (containerWidth * this.get('fraction') - (this.$().outerWidth() / 2.0)) + 50;
		var placementPositionX = Math.max(this.lowerLimitX(), Math.min(leftPos, this.upperLimitX()));
		this.setCssLeft(placementPositionX);
		//        console.debug("Fraction update: ", leftPos, placementPositionX);
	}).on('didInsertElement'),
	didInsertElement() {
		this.$().on('mousedown.scrub-handle', this.mousedown.bind(this));
	},
	willDestroyElement() {
		this.$().off('.scrub-handle');
		this.$().parent().off(".scrub-handle");
	},
	mousedown(e) {
		let self = this;

		this.set('dragging', true);
		this.set('dragStartClickOffsetX', this.objPosX(e.clientX));
		//        console.debug('touchstart');
		this.notifyPropertyChange('fraction');
		e.stopPropagation();

		$('body').on('mousemove.scrub-handle', this.mousemove.bind(this));
		$('body').on('mouseup.scrub-handle', () => {
			$('body').off('mouseup.scrub-handle');
			$('body').off('mousemove.scrub-handle');
		});
	},
	mouseup() {
		this.set('dragging', false);
		return true;
	},

	lowerLimitX() {
		return -(this.$().parent().innerWidth() - 50);
	},

	upperLimitX() {
		return this.$().parent().innerWidth() - 50;
	},

	mousemove(e) {
		var $parent = this.$().parent();
		var parentOffset = $parent.offset();
		var boundingLeftX = parentOffset.left + 50;
		//actual click position needs to be adjusted by where the click started
		var posX = (e.clientX - boundingLeftX); // - this.get('dragStartClickOffsetX');
		//            console.debug('newObjectPositionX: new obj posit: ', posX);
		var fraction = (1.0 * posX) / ($parent.innerWidth() - 100);
		fraction = Math.max(this.get('lowerLimit'), Math.min(fraction, this.get('upperLimit')));
		//            console.debug('fraction ', fraction);
		this.set('fraction', fraction);

	},
	//Returns the relative x position at which the object was clicked
	objPosX(clientX) {
		var objLeft = this.$().offset().left;
		return clientX - objLeft;
	},
	setCssLeft(pixels) {
		this.$().css('left', pixels + "px");
	}
});
