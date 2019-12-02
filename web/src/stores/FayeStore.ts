import {action, computed, observable} from "mobx";

import {CustomWindow} from "../customWindow";
import {EFayeChannel} from "../EFayeChannel";

declare let window: CustomWindow;

export class FayeStore<T> {
	@observable
	messages: T[] = [];

	@observable
	private _currentIndex: number | undefined;

	private subscription;
	private readonly channel: EFayeChannel;

	constructor(channel: EFayeChannel) {
		this.channel = channel;
		this.subscription = window.fayeClient.subscribe(this.channel, this.addMessage);
	}

	unsubscribe() {
		this.subscription.unsubscribe();
	}

	@computed
	get currentIndex(): number | undefined {
		if( this.messages.length === 0 ) {
			return undefined;
		}

		if( typeof this._currentIndex !== "undefined") {
			return this._currentIndex;
		}

		return this.messages.length - 1;
	}

	@computed
	get current(): T | undefined {
		if( typeof this.currentIndex !== "undefined" && this.currentIndex >= 0 && this.currentIndex < this.messages.length ) {
			return this.messages[this.currentIndex];
		}
		return undefined;
	}

	@action
	step(step: number) {
		const newIdx = (this.currentIndex || 0) + step;
		if( newIdx >= 0 && newIdx < this.messages.length ) {
			this._currentIndex = newIdx;
		}
	}

	@action.bound
	private addMessage(msg: T) {
		this.messages.push(msg);
	}

	async publish(message: T) {
		return window.fayeClient.publish(this.channel, message);
	}


}