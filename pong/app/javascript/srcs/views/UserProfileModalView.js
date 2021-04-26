import $ from 'jquery/src/jquery';
import common from '../common';
import UserInfoView from './UserInfoView';
import UserHistoryCollectionView from './UserHistoryCollectionView';
import model from '../models';

const UserProfileModalView = common.View.extend({
  el: '#user-profile-modal',
  events: {},
  onInitialize(obj) {
    this.userId = obj;
    this.addRegion('userinfo', '#user-info');
    this.addRegion('userhistory', '#user-history');
    const user = new model.UserModel(this.userId);
    const self = this;
    user.fetch({
      success() {
        self.show('userinfo', new UserInfoView({ model: user }));
        self.show('userhistory', new UserHistoryCollectionView(this.userId));
      },
    });
    $(this.el).modal('show');
    const view = this;
    $(this.el).on('hide.bs.modal', function destroy() {
      view.destroy();
    });
  },
  onRender() {
    // this.addRegion('userinfo', '#user-info');
    // this.addRegion('userhistroy', '#user-history');
    // this.show('userinfo', new UserInfoView(this.userId));
    // this.show('userhistory', new UserHistoryCollectionView(this.userId));
  },
  onDestroy() {},
});

export default UserProfileModalView;
